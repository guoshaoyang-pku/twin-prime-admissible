import Sound
import lean_certs.cert_27_66

open CertVerify

theorem H27_gt_66 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 27) (d := 66) (c := cert_27_66) (by native_decide)
