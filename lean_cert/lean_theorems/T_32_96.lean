import Sound
import lean_certs.cert_32_96

open CertVerify

theorem H32_gt_96 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 32) (d := 96) (c := cert_32_96) (by native_decide)
