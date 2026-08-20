import Sound
import lean_certs.cert_23_90

open CertVerify

theorem H23_gt_90 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 23) (d := 90) (c := cert_23_90) (by native_decide)
