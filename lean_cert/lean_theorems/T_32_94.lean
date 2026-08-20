import Sound
import lean_certs.cert_32_94

open CertVerify

theorem H32_gt_94 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 32) (d := 94) (c := cert_32_94) (by native_decide)
