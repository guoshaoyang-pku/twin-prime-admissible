import Sound
import lean_certs.cert_39_142

open CertVerify

theorem H39_gt_142 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 39) (d := 142) (c := cert_39_142) (by native_decide)
