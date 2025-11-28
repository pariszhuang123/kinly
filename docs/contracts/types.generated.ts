export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          extensions?: Json
          operationName?: string
          query?: string
          variables?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      analytics_events: {
        Row: {
          event_type: string
          home_id: string | null
          id: string
          metadata: Json
          occurred_at: string
          user_id: string
        }
        Insert: {
          event_type: string
          home_id?: string | null
          id?: string
          metadata?: Json
          occurred_at?: string
          user_id: string
        }
        Update: {
          event_type?: string
          home_id?: string | null
          id?: string
          metadata?: Json
          occurred_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "analytics_events_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "analytics_events_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      app_version: {
        Row: {
          id: string
          is_current: boolean
          min_supported_version: string
          notes: string | null
          release_date: string
          version_number: string
        }
        Insert: {
          id?: string
          is_current?: boolean
          min_supported_version: string
          notes?: string | null
          release_date?: string
          version_number: string
        }
        Update: {
          id?: string
          is_current?: boolean
          min_supported_version?: string
          notes?: string | null
          release_date?: string
          version_number?: string
        }
        Relationships: []
      }
      avatars: {
        Row: {
          category: string
          created_at: string
          id: string
          name: string
          storage_path: string
        }
        Insert: {
          category: string
          created_at?: string
          id?: string
          name?: string
          storage_path: string
        }
        Update: {
          category?: string
          created_at?: string
          id?: string
          name?: string
          storage_path?: string
        }
        Relationships: []
      }
      chore_events: {
        Row: {
          actor_user_id: string
          chore_id: string
          event_type: Database["public"]["Enums"]["chore_event_type"]
          from_state: Database["public"]["Enums"]["chore_state"] | null
          home_id: string
          id: string
          occurred_at: string
          payload: Json
          to_state: Database["public"]["Enums"]["chore_state"] | null
        }
        Insert: {
          actor_user_id: string
          chore_id: string
          event_type: Database["public"]["Enums"]["chore_event_type"]
          from_state?: Database["public"]["Enums"]["chore_state"] | null
          home_id: string
          id?: string
          occurred_at?: string
          payload?: Json
          to_state?: Database["public"]["Enums"]["chore_state"] | null
        }
        Update: {
          actor_user_id?: string
          chore_id?: string
          event_type?: Database["public"]["Enums"]["chore_event_type"]
          from_state?: Database["public"]["Enums"]["chore_state"] | null
          home_id?: string
          id?: string
          occurred_at?: string
          payload?: Json
          to_state?: Database["public"]["Enums"]["chore_state"] | null
        }
        Relationships: [
          {
            foreignKeyName: "chore_events_actor_user_id_fkey"
            columns: ["actor_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "chore_events_chore_id_fkey"
            columns: ["chore_id"]
            isOneToOne: false
            referencedRelation: "chores"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "chore_events_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
        ]
      }
      chores: {
        Row: {
          assignee_user_id: string | null
          completed_at: string | null
          created_at: string
          created_by_user_id: string
          expectation_photo_path: string | null
          home_id: string
          how_to_video_url: string | null
          id: string
          name: string
          next_occurrence: string | null
          notes: string | null
          recurrence: Database["public"]["Enums"]["recurrence_interval"]
          recurrence_cursor: string | null
          start_date: string
          state: Database["public"]["Enums"]["chore_state"]
          updated_at: string
        }
        Insert: {
          assignee_user_id?: string | null
          completed_at?: string | null
          created_at?: string
          created_by_user_id: string
          expectation_photo_path?: string | null
          home_id: string
          how_to_video_url?: string | null
          id?: string
          name: string
          next_occurrence?: string | null
          notes?: string | null
          recurrence?: Database["public"]["Enums"]["recurrence_interval"]
          recurrence_cursor?: string | null
          start_date?: string
          state?: Database["public"]["Enums"]["chore_state"]
          updated_at?: string
        }
        Update: {
          assignee_user_id?: string | null
          completed_at?: string | null
          created_at?: string
          created_by_user_id?: string
          expectation_photo_path?: string | null
          home_id?: string
          how_to_video_url?: string | null
          id?: string
          name?: string
          next_occurrence?: string | null
          notes?: string | null
          recurrence?: Database["public"]["Enums"]["recurrence_interval"]
          recurrence_cursor?: string | null
          start_date?: string
          state?: Database["public"]["Enums"]["chore_state"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "chores_assignee_user_id_fkey"
            columns: ["assignee_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "chores_created_by_user_id_fkey"
            columns: ["created_by_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "chores_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
        ]
      }
      expense_splits: {
        Row: {
          amount_cents: number
          debtor_user_id: string
          expense_id: string
          marked_paid_at: string | null
          status: Database["public"]["Enums"]["expense_share_status"]
        }
        Insert: {
          amount_cents: number
          debtor_user_id: string
          expense_id: string
          marked_paid_at?: string | null
          status?: Database["public"]["Enums"]["expense_share_status"]
        }
        Update: {
          amount_cents?: number
          debtor_user_id?: string
          expense_id?: string
          marked_paid_at?: string | null
          status?: Database["public"]["Enums"]["expense_share_status"]
        }
        Relationships: [
          {
            foreignKeyName: "expense_splits_debtor_user_id_fkey"
            columns: ["debtor_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "expense_splits_expense_id_fkey"
            columns: ["expense_id"]
            isOneToOne: false
            referencedRelation: "expenses"
            referencedColumns: ["id"]
          },
        ]
      }
      expenses: {
        Row: {
          amount_cents: number
          created_at: string
          created_by_user_id: string
          description: string
          home_id: string
          id: string
          notes: string | null
          split_type: Database["public"]["Enums"]["expense_split_type"] | null
          status: Database["public"]["Enums"]["expense_status"]
          updated_at: string
        }
        Insert: {
          amount_cents: number
          created_at?: string
          created_by_user_id: string
          description: string
          home_id: string
          id?: string
          notes?: string | null
          split_type?: Database["public"]["Enums"]["expense_split_type"] | null
          status?: Database["public"]["Enums"]["expense_status"]
          updated_at?: string
        }
        Update: {
          amount_cents?: number
          created_at?: string
          created_by_user_id?: string
          description?: string
          home_id?: string
          id?: string
          notes?: string | null
          split_type?: Database["public"]["Enums"]["expense_split_type"] | null
          status?: Database["public"]["Enums"]["expense_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "expenses_created_by_user_id_fkey"
            columns: ["created_by_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "expenses_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
        ]
      }
      gratitude_wall_posts: {
        Row: {
          author_user_id: string
          created_at: string
          home_id: string
          id: string
          message: string | null
          mood: Database["public"]["Enums"]["mood_scale"]
        }
        Insert: {
          author_user_id: string
          created_at?: string
          home_id: string
          id?: string
          message?: string | null
          mood: Database["public"]["Enums"]["mood_scale"]
        }
        Update: {
          author_user_id?: string
          created_at?: string
          home_id?: string
          id?: string
          message?: string | null
          mood?: Database["public"]["Enums"]["mood_scale"]
        }
        Relationships: [
          {
            foreignKeyName: "gratitude_wall_posts_author_user_id_fkey"
            columns: ["author_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "gratitude_wall_posts_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
        ]
      }
      gratitude_wall_reads: {
        Row: {
          home_id: string
          last_read_at: string
          user_id: string
        }
        Insert: {
          home_id: string
          last_read_at?: string
          user_id: string
        }
        Update: {
          home_id?: string
          last_read_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "gratitude_wall_reads_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "gratitude_wall_reads_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      home_entitlements: {
        Row: {
          created_at: string
          expires_at: string | null
          home_id: string
          plan: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          expires_at?: string | null
          home_id: string
          plan?: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          expires_at?: string | null
          home_id?: string
          plan?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "home_entitlements_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: true
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
        ]
      }
      home_mood_entries: {
        Row: {
          comment: string | null
          created_at: string
          gratitude_post_id: string | null
          home_id: string
          id: string
          iso_week: number
          iso_week_year: number
          mood: Database["public"]["Enums"]["mood_scale"]
          user_id: string
        }
        Insert: {
          comment?: string | null
          created_at?: string
          gratitude_post_id?: string | null
          home_id: string
          id?: string
          iso_week: number
          iso_week_year: number
          mood: Database["public"]["Enums"]["mood_scale"]
          user_id: string
        }
        Update: {
          comment?: string | null
          created_at?: string
          gratitude_post_id?: string | null
          home_id?: string
          id?: string
          iso_week?: number
          iso_week_year?: number
          mood?: Database["public"]["Enums"]["mood_scale"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "home_mood_entries_gratitude_post_id_fkey"
            columns: ["gratitude_post_id"]
            isOneToOne: false
            referencedRelation: "gratitude_wall_posts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "home_mood_entries_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "home_mood_entries_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      home_mood_feedback_counters: {
        Row: {
          feedback_count: number
          first_feedback_at: string | null
          home_id: string
          last_feedback_at: string | null
          last_nps_at: string | null
          last_nps_feedback_count: number
          last_nps_score: number | null
          nps_required: boolean
          user_id: string
        }
        Insert: {
          feedback_count?: number
          first_feedback_at?: string | null
          home_id: string
          last_feedback_at?: string | null
          last_nps_at?: string | null
          last_nps_feedback_count?: number
          last_nps_score?: number | null
          nps_required?: boolean
          user_id: string
        }
        Update: {
          feedback_count?: number
          first_feedback_at?: string | null
          home_id?: string
          last_feedback_at?: string | null
          last_nps_at?: string | null
          last_nps_feedback_count?: number
          last_nps_score?: number | null
          nps_required?: boolean
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "home_mood_feedback_counters_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "home_mood_feedback_counters_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      home_nps: {
        Row: {
          created_at: string
          home_id: string
          id: string
          nps_feedback_count: number
          score: number
          user_id: string
        }
        Insert: {
          created_at?: string
          home_id: string
          id?: string
          nps_feedback_count: number
          score: number
          user_id: string
        }
        Update: {
          created_at?: string
          home_id?: string
          id?: string
          nps_feedback_count?: number
          score?: number
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "home_nps_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "home_nps_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      home_plan_limits: {
        Row: {
          max_value: number
          metric: Database["public"]["Enums"]["home_usage_metric"]
          plan: string
        }
        Insert: {
          max_value: number
          metric: Database["public"]["Enums"]["home_usage_metric"]
          plan: string
        }
        Update: {
          max_value?: number
          metric?: Database["public"]["Enums"]["home_usage_metric"]
          plan?: string
        }
        Relationships: []
      }
      home_usage_counters: {
        Row: {
          active_chores: number
          active_members: number
          chore_photos: number
          home_id: string
          updated_at: string
        }
        Insert: {
          active_chores?: number
          active_members?: number
          chore_photos?: number
          home_id: string
          updated_at?: string
        }
        Update: {
          active_chores?: number
          active_members?: number
          chore_photos?: number
          home_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "home_usage_counters_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: true
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
        ]
      }
      homes: {
        Row: {
          created_at: string
          deactivated_at: string | null
          id: string
          is_active: boolean
          owner_user_id: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          deactivated_at?: string | null
          id?: string
          is_active?: boolean
          owner_user_id: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          deactivated_at?: string | null
          id?: string
          is_active?: boolean
          owner_user_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "homes_owner_user_id_fkey"
            columns: ["owner_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      invites: {
        Row: {
          code: string
          created_at: string
          home_id: string
          id: string
          revoked_at: string | null
          used_count: number
        }
        Insert: {
          code: string
          created_at?: string
          home_id: string
          id?: string
          revoked_at?: string | null
          used_count?: number
        }
        Update: {
          code?: string
          created_at?: string
          home_id?: string
          id?: string
          revoked_at?: string | null
          used_count?: number
        }
        Relationships: [
          {
            foreignKeyName: "invites_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
        ]
      }
      memberships: {
        Row: {
          created_at: string
          home_id: string
          id: string
          is_current: boolean | null
          role: string
          updated_at: string
          user_id: string
          valid_from: string
          valid_to: string | null
          validity: unknown
        }
        Insert: {
          created_at?: string
          home_id: string
          id?: string
          is_current?: boolean | null
          role: string
          updated_at?: string
          user_id: string
          valid_from?: string
          valid_to?: string | null
          validity?: unknown
        }
        Update: {
          created_at?: string
          home_id?: string
          id?: string
          is_current?: boolean | null
          role?: string
          updated_at?: string
          user_id?: string
          valid_from?: string
          valid_to?: string | null
          validity?: unknown
        }
        Relationships: [
          {
            foreignKeyName: "memberships_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "memberships_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          avatar_id: string
          created_at: string
          deactivated_at: string | null
          email: string | null
          full_name: string | null
          id: string
          updated_at: string
          username: string
        }
        Insert: {
          avatar_id: string
          created_at?: string
          deactivated_at?: string | null
          email?: string | null
          full_name?: string | null
          id: string
          updated_at?: string
          username: string
        }
        Update: {
          avatar_id?: string
          created_at?: string
          deactivated_at?: string | null
          email?: string | null
          full_name?: string | null
          id?: string
          updated_at?: string
          username?: string
        }
        Relationships: [
          {
            foreignKeyName: "profiles_avatar_id_fkey"
            columns: ["avatar_id"]
            isOneToOne: false
            referencedRelation: "avatars"
            referencedColumns: ["id"]
          },
        ]
      }
      reserved_usernames: {
        Row: {
          name: string
        }
        Insert: {
          name: string
        }
        Update: {
          name?: string
        }
        Relationships: []
      }
      shared_preferences: {
        Row: {
          created_at: string
          pref_key: string
          pref_value: Json
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          pref_key: string
          pref_value?: Json
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          pref_key?: string
          pref_value?: Json
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "shared_preferences_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      user_subscriptions: {
        Row: {
          created_at: string
          current_period_end_at: string | null
          home_id: string | null
          id: string
          last_purchase_at: string | null
          last_synced_at: string
          latest_transaction_id: string | null
          original_purchase_at: string | null
          product_id: string
          rc_app_user_id: string
          rc_entitlement_id: string
          status: Database["public"]["Enums"]["subscription_status"]
          store: Database["public"]["Enums"]["subscription_store"]
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          current_period_end_at?: string | null
          home_id?: string | null
          id?: string
          last_purchase_at?: string | null
          last_synced_at?: string
          latest_transaction_id?: string | null
          original_purchase_at?: string | null
          product_id: string
          rc_app_user_id: string
          rc_entitlement_id: string
          status: Database["public"]["Enums"]["subscription_status"]
          store: Database["public"]["Enums"]["subscription_store"]
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          current_period_end_at?: string | null
          home_id?: string | null
          id?: string
          last_purchase_at?: string | null
          last_synced_at?: string
          latest_transaction_id?: string | null
          original_purchase_at?: string | null
          product_id?: string
          rc_app_user_id?: string
          rc_entitlement_id?: string
          status?: Database["public"]["Enums"]["subscription_status"]
          store?: Database["public"]["Enums"]["subscription_store"]
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_subscriptions_home_id_fkey"
            columns: ["home_id"]
            isOneToOne: false
            referencedRelation: "homes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_subscriptions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      _assert_authenticated: { Args: never; Returns: undefined }
      _assert_home_active: { Args: { p_home_id: string }; Returns: undefined }
      _assert_home_member: { Args: { p_home_id: string }; Returns: undefined }
      _chores_base_for_home: {
        Args: { p_home_id: string }
        Returns: {
          assignee_avatar_storage_path: string
          assignee_full_name: string
          assignee_user_id: string
          created_at: string
          created_by_user_id: string
          current_due_date: string
          home_id: string
          id: string
          name: string
          state: Database["public"]["Enums"]["chore_state"]
        }[]
      }
      _current_user_id: { Args: never; Returns: string }
      _ensure_unique_avatar_for_home: {
        Args: { p_home_id: string; p_user_id: string }
        Returns: string
      }
      _expenses_prepare_split_buffer: {
        Args: {
          p_amount_cents: number
          p_creator_id: string
          p_home_id: string
          p_member_ids?: string[]
          p_split_mode: Database["public"]["Enums"]["expense_split_type"]
          p_splits?: Json
        }
        Returns: undefined
      }
      _gen_invite_code: { Args: never; Returns: string }
      _gen_unique_username: {
        Args: { p_email: string; p_id: string }
        Returns: string
      }
      _home_assert_quota: {
        Args: { p_deltas: Json; p_home_id: string }
        Returns: undefined
      }
      _home_attach_subscription_to_home: {
        Args: { _home_id: string; _user_id: string }
        Returns: undefined
      }
      _home_detach_subscription_to_home: {
        Args: { _home_id: string; _user_id: string }
        Returns: undefined
      }
      _home_effective_plan: { Args: { p_home_id: string }; Returns: string }
      _home_is_premium: { Args: { p_home_id: string }; Returns: boolean }
      _home_usage_apply_delta: {
        Args: { p_deltas: Json; p_home_id: string }
        Returns: {
          active_chores: number
          active_members: number
          chore_photos: number
          home_id: string
          updated_at: string
        }
        SetofOptions: {
          from: "*"
          to: "home_usage_counters"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      api_assert: {
        Args: {
          p_code: string
          p_condition: boolean
          p_details?: Json
          p_hint?: string
          p_msg: string
          p_sqlstate?: string
        }
        Returns: undefined
      }
      api_error: {
        Args: {
          p_code: string
          p_details?: Json
          p_hint?: string
          p_msg: string
          p_sqlstate?: string
        }
        Returns: undefined
      }
      avatars_list_for_home: {
        Args: { p_home_id: string }
        Returns: {
          category: string
          id: string
          storage_path: string
        }[]
      }
      check_app_version: { Args: { client_version: string }; Returns: Json }
      chore_complete: { Args: { _chore_id: string }; Returns: Json }
      chores_cancel: { Args: { p_chore_id: string }; Returns: Json }
      chores_create: {
        Args: {
          p_assignee_user_id?: string
          p_expectation_photo_path?: string
          p_home_id: string
          p_how_to_video_url?: string
          p_name: string
          p_notes?: string
          p_recurrence?: Database["public"]["Enums"]["recurrence_interval"]
          p_start_date?: string
        }
        Returns: {
          assignee_user_id: string | null
          completed_at: string | null
          created_at: string
          created_by_user_id: string
          expectation_photo_path: string | null
          home_id: string
          how_to_video_url: string | null
          id: string
          name: string
          next_occurrence: string | null
          notes: string | null
          recurrence: Database["public"]["Enums"]["recurrence_interval"]
          recurrence_cursor: string | null
          start_date: string
          state: Database["public"]["Enums"]["chore_state"]
          updated_at: string
        }
        SetofOptions: {
          from: "*"
          to: "chores"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      chores_get_for_home: {
        Args: { p_chore_id: string; p_home_id: string }
        Returns: Json
      }
      chores_list_for_home: {
        Args: { p_home_id: string }
        Returns: {
          assignee_avatar_storage_path: string
          assignee_full_name: string
          assignee_user_id: string
          home_id: string
          id: string
          name: string
          start_date: string
        }[]
      }
      chores_reassign_on_member_leave: {
        Args: { v_home_id: string; v_user_id: string }
        Returns: undefined
      }
      chores_update: {
        Args: {
          p_assignee_user_id: string
          p_chore_id: string
          p_expectation_photo_path?: string
          p_how_to_video_url?: string
          p_name: string
          p_notes?: string
          p_recurrence?: Database["public"]["Enums"]["recurrence_interval"]
          p_start_date: string
        }
        Returns: {
          assignee_user_id: string | null
          completed_at: string | null
          created_at: string
          created_by_user_id: string
          expectation_photo_path: string | null
          home_id: string
          how_to_video_url: string | null
          id: string
          name: string
          next_occurrence: string | null
          notes: string | null
          recurrence: Database["public"]["Enums"]["recurrence_interval"]
          recurrence_cursor: string | null
          start_date: string
          state: Database["public"]["Enums"]["chore_state"]
          updated_at: string
        }
        SetofOptions: {
          from: "*"
          to: "chores"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      expenses_cancel: {
        Args: { p_expense_id: string }
        Returns: {
          amount_cents: number
          created_at: string
          created_by_user_id: string
          description: string
          home_id: string
          id: string
          notes: string | null
          split_type: Database["public"]["Enums"]["expense_split_type"] | null
          status: Database["public"]["Enums"]["expense_status"]
          updated_at: string
        }
        SetofOptions: {
          from: "*"
          to: "expenses"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      expenses_create: {
        Args: {
          p_amount_cents: number
          p_description: string
          p_home_id: string
          p_member_ids?: string[]
          p_notes?: string
          p_split_mode?: Database["public"]["Enums"]["expense_split_type"]
          p_splits?: Json
        }
        Returns: {
          amount_cents: number
          created_at: string
          created_by_user_id: string
          description: string
          home_id: string
          id: string
          notes: string | null
          split_type: Database["public"]["Enums"]["expense_split_type"] | null
          status: Database["public"]["Enums"]["expense_status"]
          updated_at: string
        }
        SetofOptions: {
          from: "*"
          to: "expenses"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      expenses_edit: {
        Args: {
          p_amount_cents: number
          p_description: string
          p_expense_id: string
          p_member_ids?: string[]
          p_notes?: string
          p_split_mode?: Database["public"]["Enums"]["expense_split_type"]
          p_splits?: Json
        }
        Returns: {
          amount_cents: number
          created_at: string
          created_by_user_id: string
          description: string
          home_id: string
          id: string
          notes: string | null
          split_type: Database["public"]["Enums"]["expense_split_type"] | null
          status: Database["public"]["Enums"]["expense_status"]
          updated_at: string
        }
        SetofOptions: {
          from: "*"
          to: "expenses"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      expenses_get_created_by_me: { Args: { p_home_id: string }; Returns: Json }
      expenses_get_current_owed: { Args: { p_home_id: string }; Returns: Json }
      expenses_get_for_edit: { Args: { p_expense_id: string }; Returns: Json }
      expenses_mark_share_paid: {
        Args: { p_expense_id: string }
        Returns: {
          amount_cents: number
          debtor_user_id: string
          expense_id: string
          marked_paid_at: string | null
          status: Database["public"]["Enums"]["expense_share_status"]
        }
        SetofOptions: {
          from: "*"
          to: "expense_splits"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      gratitude_wall_list: {
        Args: {
          p_cursor_created_at?: string
          p_cursor_id?: string
          p_home_id: string
          p_limit?: number
        }
        Returns: {
          author_avatar_url: string
          author_user_id: string
          author_username: string
          created_at: string
          message: string
          mood: Database["public"]["Enums"]["mood_scale"]
          post_id: string
        }[]
      }
      gratitude_wall_mark_read: {
        Args: { p_home_id: string }
        Returns: boolean
      }
      gratitude_wall_status: {
        Args: { p_home_id: string }
        Returns: {
          has_unread: boolean
          last_read_at: string
        }[]
      }
      home_assignees_list: {
        Args: { p_home_id: string }
        Returns: {
          avatar_storage_path: string
          email: string
          full_name: string
          user_id: string
        }[]
      }
      home_entitlements_refresh: {
        Args: { _home_id: string }
        Returns: undefined
      }
      home_nps_get_status: { Args: { p_home_id: string }; Returns: boolean }
      home_nps_submit: {
        Args: { p_home_id: string; p_score: number }
        Returns: {
          created_at: string
          home_id: string
          id: string
          nps_feedback_count: number
          score: number
          user_id: string
        }
        SetofOptions: {
          from: "*"
          to: "home_nps"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      homes_create_with_invite: { Args: never; Returns: Json }
      homes_join: { Args: { p_code: string }; Returns: Json }
      homes_leave: { Args: { p_home_id: string }; Returns: Json }
      homes_transfer_owner: {
        Args: { p_home_id: string; p_new_owner_id: string }
        Returns: Json
      }
      invites_get_active: {
        Args: { p_home_id: string }
        Returns: {
          code: string
          created_at: string
          home_id: string
          id: string
          revoked_at: string | null
          used_count: number
        }
        SetofOptions: {
          from: "*"
          to: "invites"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      invites_revoke: { Args: { p_home_id: string }; Returns: Json }
      invites_rotate: { Args: { p_home_id: string }; Returns: Json }
      is_home_owner: {
        Args: { p_home_id: string; p_user_id?: string }
        Returns: boolean
      }
      members_list_active_by_home: {
        Args: { p_exclude_self?: boolean; p_home_id: string }
        Returns: {
          avatar_url: string
          can_transfer_to: boolean
          role: string
          user_id: string
          username: string
          valid_from: string
        }[]
      }
      membership_me_current: { Args: never; Returns: Json }
      mood_get_current_weekly: { Args: { p_home_id: string }; Returns: boolean }
      mood_submit: {
        Args: {
          p_add_to_wall?: boolean
          p_comment?: string
          p_home_id: string
          p_mood: Database["public"]["Enums"]["mood_scale"]
        }
        Returns: {
          entry_id: string
          gratitude_post_id: string
        }[]
      }
      profile_identity_update: {
        Args: { p_avatar_id: string; p_username: string }
        Returns: {
          avatar_id: string
          avatar_storage_path: string
          username: string
        }[]
      }
      profile_me: {
        Args: never
        Returns: {
          avatar_storage_path: string
          user_id: string
          username: string
        }[]
      }
      today_flow_list: {
        Args: {
          p_home_id: string
          p_state: Database["public"]["Enums"]["chore_state"]
        }
        Returns: {
          home_id: string
          id: string
          name: string
          start_date: string
          state: Database["public"]["Enums"]["chore_state"]
        }[]
      }
    }
    Enums: {
      chore_event_type: "create" | "activate" | "update" | "complete" | "cancel"
      chore_state: "draft" | "active" | "completed" | "cancelled"
      expense_share_status: "unpaid" | "paid"
      expense_split_type: "equal" | "custom"
      expense_status: "draft" | "active" | "cancelled"
      home_usage_metric: "active_chores" | "chore_photos" | "active_members"
      mood_scale:
        | "sunny"
        | "partially_sunny"
        | "cloudy"
        | "rainy"
        | "thunderstorm"
      recurrence_interval:
        | "none"
        | "daily"
        | "weekly"
        | "every_2_weeks"
        | "monthly"
        | "every_2_months"
        | "annual"
      subscription_status: "active" | "cancelled" | "expired" | "inactive"
      subscription_store: "app_store" | "play_store" | "stripe" | "promotional"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {
      chore_event_type: ["create", "activate", "update", "complete", "cancel"],
      chore_state: ["draft", "active", "completed", "cancelled"],
      expense_share_status: ["unpaid", "paid"],
      expense_split_type: ["equal", "custom"],
      expense_status: ["draft", "active", "cancelled"],
      home_usage_metric: ["active_chores", "chore_photos", "active_members"],
      mood_scale: [
        "sunny",
        "partially_sunny",
        "cloudy",
        "rainy",
        "thunderstorm",
      ],
      recurrence_interval: [
        "none",
        "daily",
        "weekly",
        "every_2_weeks",
        "monthly",
        "every_2_months",
        "annual",
      ],
      subscription_status: ["active", "cancelled", "expired", "inactive"],
      subscription_store: ["app_store", "play_store", "stripe", "promotional"],
    },
  },
} as const

