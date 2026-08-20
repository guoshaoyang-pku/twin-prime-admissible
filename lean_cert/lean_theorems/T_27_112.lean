import Sound
import lean_certs.cert_27_112

open CertVerify

theorem H27_gt_112 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 27) (d := 112) (c := cert_27_112) (by native_decide)
