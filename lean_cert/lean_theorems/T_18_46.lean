import Sound
import lean_certs.cert_18_46

open CertVerify

theorem H18_gt_46 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 18) (d := 46) (c := cert_18_46) (by native_decide)
