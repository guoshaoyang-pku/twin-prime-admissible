import Sound
import lean_certs.cert_18_56

open CertVerify

theorem H18_gt_56 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 18) (d := 56) (c := cert_18_56) (by native_decide)
