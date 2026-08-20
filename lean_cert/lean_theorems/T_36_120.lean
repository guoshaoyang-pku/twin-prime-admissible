import Sound
import lean_certs.cert_36_120

open CertVerify

theorem H36_gt_120 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 36) (d := 120) (c := cert_36_120) (by native_decide)
