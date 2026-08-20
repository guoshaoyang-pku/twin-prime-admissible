import Sound
import lean_certs.cert_41_120

open CertVerify

theorem H41_gt_120 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 41) (d := 120) (c := cert_41_120) (by native_decide)
