import Sound
import lean_certs.cert_42_88

open CertVerify

theorem H42_gt_88 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 42) (d := 88) (c := cert_42_88) (by native_decide)
