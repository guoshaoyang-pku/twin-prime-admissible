import Sound
import lean_certs.cert_27_56

open CertVerify

theorem H27_gt_56 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 27) (d := 56) (c := cert_27_56) (by native_decide)
