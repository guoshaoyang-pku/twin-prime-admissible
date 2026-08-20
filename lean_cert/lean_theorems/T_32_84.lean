import Sound
import lean_certs.cert_32_84

open CertVerify

theorem H32_gt_84 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 32) (d := 84) (c := cert_32_84) (by native_decide)
