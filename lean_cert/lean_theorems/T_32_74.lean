import Sound
import lean_certs.cert_32_74

open CertVerify

theorem H32_gt_74 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 32) (d := 74) (c := cert_32_74) (by native_decide)
