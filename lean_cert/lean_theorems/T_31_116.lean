import Sound
import lean_certs.cert_31_116

open CertVerify

theorem H31_gt_116 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 31) (d := 116) (c := cert_31_116) (by native_decide)
