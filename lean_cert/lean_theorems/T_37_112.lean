import Sound
import lean_certs.cert_37_112

open CertVerify

theorem H37_gt_112 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 37) (d := 112) (c := cert_37_112) (by native_decide)
