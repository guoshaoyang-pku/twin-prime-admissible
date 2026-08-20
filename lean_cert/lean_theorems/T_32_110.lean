import Sound
import lean_certs.cert_32_110

open CertVerify

theorem H32_gt_110 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 32) (d := 110) (c := cert_32_110) (by native_decide)
