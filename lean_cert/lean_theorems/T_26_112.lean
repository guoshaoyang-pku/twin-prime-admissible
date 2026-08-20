import Sound
import lean_certs.cert_26_112

open CertVerify

theorem H26_gt_112 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 26) (d := 112) (c := cert_26_112) (by native_decide)
