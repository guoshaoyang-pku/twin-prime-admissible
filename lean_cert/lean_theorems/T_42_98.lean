import Sound
import lean_certs.cert_42_98

open CertVerify

theorem H42_gt_98 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 42) (d := 98) (c := cert_42_98) (by native_decide)
