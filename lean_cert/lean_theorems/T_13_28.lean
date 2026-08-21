import Sound
import lean_certs.cert_13_28

open CertVerify

theorem H13_gt_28 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 28 := by
  exact certValidRoot_sound (k := 13) (d := 28) (c := cert_13_28) (by native_decide)
