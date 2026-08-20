import Sound
import lean_certs.cert_34_112

open CertVerify

theorem H34_gt_112 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 34) (d := 112) (c := cert_34_112) (by native_decide)
