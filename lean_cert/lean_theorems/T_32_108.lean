import Sound
import lean_certs.cert_32_108

open CertVerify

theorem H32_gt_108 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 32) (d := 108) (c := cert_32_108) (by native_decide)
