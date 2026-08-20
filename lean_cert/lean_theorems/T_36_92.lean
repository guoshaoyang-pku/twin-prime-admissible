import Sound
import lean_certs.cert_36_92

open CertVerify

theorem H36_gt_92 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 36) (d := 92) (c := cert_36_92) (by native_decide)
