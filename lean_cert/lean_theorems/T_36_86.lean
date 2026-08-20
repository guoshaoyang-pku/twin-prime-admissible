import Sound
import lean_certs.cert_36_86

open CertVerify

theorem H36_gt_86 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 36) (d := 86) (c := cert_36_86) (by native_decide)
