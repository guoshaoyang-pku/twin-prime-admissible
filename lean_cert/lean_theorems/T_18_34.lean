import Sound
import lean_certs.cert_18_34

open CertVerify

theorem H18_gt_34 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 18) (d := 34) (c := cert_18_34) (by native_decide)
