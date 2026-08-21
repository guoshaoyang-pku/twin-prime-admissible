import Sound
import lean_certs.cert_11_20

open CertVerify

theorem H11_gt_20 : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 20 := by
  exact certValidRoot_sound (k := 11) (d := 20) (c := cert_11_20) (by native_decide)
