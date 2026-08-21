import Sound
import lean_certs.cert_16_32

open CertVerify

theorem H16_gt_32 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 32 := by
  exact certValidRoot_sound (k := 16) (d := 32) (c := cert_16_32) (by native_decide)
