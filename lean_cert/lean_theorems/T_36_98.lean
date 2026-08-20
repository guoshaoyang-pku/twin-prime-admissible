import Sound
import lean_certs.cert_36_98

open CertVerify

theorem H36_gt_98 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 36) (d := 98) (c := cert_36_98) (by native_decide)
