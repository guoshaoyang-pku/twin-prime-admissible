import Sound
import lean_certs.cert_32_112

open CertVerify

theorem H32_gt_112 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 32) (d := 112) (c := cert_32_112) (by native_decide)
