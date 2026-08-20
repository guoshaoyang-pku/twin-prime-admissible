import Sound
import lean_certs.cert_32_80

open CertVerify

theorem H32_gt_80 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 32) (d := 80) (c := cert_32_80) (by native_decide)
