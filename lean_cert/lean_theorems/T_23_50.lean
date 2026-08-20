import Sound
import lean_certs.cert_23_50

open CertVerify

theorem H23_gt_50 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 23) (d := 50) (c := cert_23_50) (by native_decide)
