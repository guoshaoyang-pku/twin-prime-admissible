import Sound
import lean_certs.cert_14_28

open CertVerify

theorem H14_gt_28 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 28 := by
  exact certValidRoot_sound (k := 14) (d := 28) (c := cert_14_28) (by native_decide)
