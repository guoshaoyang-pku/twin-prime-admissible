import Sound
import lean_certs.cert_42_96

open CertVerify

theorem H42_gt_96 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 42) (d := 96) (c := cert_42_96) (by native_decide)
