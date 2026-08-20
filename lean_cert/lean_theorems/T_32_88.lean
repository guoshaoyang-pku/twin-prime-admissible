import Sound
import lean_certs.cert_32_88

open CertVerify

theorem H32_gt_88 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 32) (d := 88) (c := cert_32_88) (by native_decide)
