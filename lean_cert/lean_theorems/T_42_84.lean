import Sound
import lean_certs.cert_42_84

open CertVerify

theorem H42_gt_84 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 42) (d := 84) (c := cert_42_84) (by native_decide)
