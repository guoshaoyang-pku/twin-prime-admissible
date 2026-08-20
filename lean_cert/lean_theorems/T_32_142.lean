import Sound
import lean_certs.cert_32_142

open CertVerify

theorem H32_gt_142 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 32) (d := 142) (c := cert_32_142) (by native_decide)
