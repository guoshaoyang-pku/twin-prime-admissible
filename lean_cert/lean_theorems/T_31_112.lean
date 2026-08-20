import Sound
import lean_certs.cert_31_112

open CertVerify

theorem H31_gt_112 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 31) (d := 112) (c := cert_31_112) (by native_decide)
