import Sound
import lean_certs.cert_11_22

open CertVerify

theorem H11_gt_22 : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 22 := by
  exact certValidRoot_sound (k := 11) (d := 22) (c := cert_11_22) (by native_decide)
