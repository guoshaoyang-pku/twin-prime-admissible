import Sound
import lean_certs.cert_14_38

open CertVerify

theorem H14_gt_38 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 14) (d := 38) (c := cert_14_38) (by native_decide)
