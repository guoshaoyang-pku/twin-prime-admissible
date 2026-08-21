import Sound
import lean_certs.cert_18_38

open CertVerify

theorem H18_gt_38 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 18) (d := 38) (c := cert_18_38) (by native_decide)
