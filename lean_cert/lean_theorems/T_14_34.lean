import Sound
import lean_certs.cert_14_34

open CertVerify

theorem H14_gt_34 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 14) (d := 34) (c := cert_14_34) (by native_decide)
