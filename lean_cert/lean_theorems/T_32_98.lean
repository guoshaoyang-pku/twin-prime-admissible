import Sound
import lean_certs.cert_32_98

open CertVerify

theorem H32_gt_98 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 32) (d := 98) (c := cert_32_98) (by native_decide)
