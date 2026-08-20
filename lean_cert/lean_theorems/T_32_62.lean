import Sound
import lean_certs.cert_32_62

open CertVerify

theorem H32_gt_62 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 32) (d := 62) (c := cert_32_62) (by native_decide)
