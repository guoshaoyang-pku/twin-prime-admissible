import Sound
import lean_certs.cert_32_116

open CertVerify

theorem H32_gt_116 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 32) (d := 116) (c := cert_32_116) (by native_decide)
