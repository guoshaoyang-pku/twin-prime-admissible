import Sound
import lean_certs.cert_36_142

open CertVerify

theorem H36_gt_142 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 36) (d := 142) (c := cert_36_142) (by native_decide)
