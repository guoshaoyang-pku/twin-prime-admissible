import Sound
import lean_certs.cert_36_118

open CertVerify

theorem H36_gt_118 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 36) (d := 118) (c := cert_36_118) (by native_decide)
