import Sound
import lean_certs.cert_41_150

open CertVerify

theorem H41_gt_150 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 41) (d := 150) (c := cert_41_150) (by native_decide)
