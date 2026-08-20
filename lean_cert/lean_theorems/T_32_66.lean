import Sound
import lean_certs.cert_32_66

open CertVerify

theorem H32_gt_66 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 32) (d := 66) (c := cert_32_66) (by native_decide)
