import Sound
import lean_certs.cert_29_112

open CertVerify

theorem H29_gt_112 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 29) (d := 112) (c := cert_29_112) (by native_decide)
