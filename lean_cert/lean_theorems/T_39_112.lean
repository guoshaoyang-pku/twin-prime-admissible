import Sound
import lean_certs.cert_39_112

open CertVerify

theorem H39_gt_112 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 39) (d := 112) (c := cert_39_112) (by native_decide)
