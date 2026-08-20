import Sound
import lean_certs.cert_32_86

open CertVerify

theorem H32_gt_86 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 32) (d := 86) (c := cert_32_86) (by native_decide)
