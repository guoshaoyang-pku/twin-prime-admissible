import Sound
import lean_certs.cert_36_160

open CertVerify

theorem H36_gt_160 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 36) (d := 160) (c := cert_36_160) (by native_decide)
