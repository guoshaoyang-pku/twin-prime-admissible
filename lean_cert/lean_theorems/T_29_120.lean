import Sound
import lean_certs.cert_29_120

open CertVerify

theorem H29_gt_120 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 29) (d := 120) (c := cert_29_120) (by native_decide)
